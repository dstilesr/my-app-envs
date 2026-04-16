data "terraform_remote_state" "cluster" {
  backend = "s3"
  config = {
    bucket       = var.remote_state_bucket
    key          = var.remote_state_key
    region       = var.remote_state_region
    use_lockfile = var.remote_state_lockfile
  }
}
