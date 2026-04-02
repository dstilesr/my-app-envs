package main

// This is code for a small lambda function to run on AWS. It will periodically check
// for RDS instances with the status=inactive tag that are not in a stopped state. It
// will shut down these instances (AWs may restart them periodically) to save cost.

import (
	"context"
	"log/slog"
	"time"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/rds"
)

const TIMEOUT = 30 * time.Second

func main() {
	lambda.Start(handleRequest)
}

// handleRequest Is in charge of the logic to process the request to the lambda
// function.
func handleRequest() error {
	// Enforce timeout
	ctx, cancel := context.WithTimeout(context.Background(), TIMEOUT)
	defer cancel()

	cfg, err := config.LoadDefaultConfig(ctx, config.WithRegion("us-west-2"))
	if err != nil {
		slog.Error("Unable to startup application", "error", err)
		return err
	}
	stopped, err := deactivateDbs(cfg, ctx)
	if err != nil {
		slog.Error("Unable to stop databases", "error", err)
		return err
	}
	slog.Info("Stopped running instances", "total", stopped)
	return nil
}

// deactivateDbs finds all RDS databases tagged as "inactive". These should be
// kept shut down, but AWS restarts them automatically after some days. Any
// instances marked as inactive but in running state are stopped.
func deactivateDbs(cfg aws.Config, ctx context.Context) (int, error) {
	service := rds.NewFromConfig(cfg)
	dbs, err := service.DescribeDBInstances(ctx, &rds.DescribeDBInstancesInput{})
	if err != nil {
		return 0, err
	}

	totalStopped := 0
	for _, db := range dbs.DBInstances {
		for _, tag := range db.TagList {
			if *tag.Key != "status" {
				continue
			} else if *tag.Value != "inactive" {
				break
			} else if *db.DBInstanceStatus == "stopping" || *db.DBInstanceStatus == "stopped" {
				break
			}
			slog.Info(
				"Found inactive database",
				"status", *db.DBInstanceStatus,
				"arn", *db.DBInstanceArn,
			)

			_, err = service.StopDBInstance(
				context.TODO(),
				&rds.StopDBInstanceInput{DBInstanceIdentifier: db.DBInstanceIdentifier},
			)
			if err != nil {
				slog.Error(
					"Unable to Stop DB Instance",
					"arn", *db.DBInstanceArn,
					"identifier", *db.DBInstanceIdentifier,
				)
				return 0, err
			}
			totalStopped += 1
			break
		}
	}

	return totalStopped, nil
}
