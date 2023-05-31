terraform {
  backend "artifactory" {
    repo  = "djdo-terraform-local"
    url   = "https://artifactory.dowjones.io/artifactory"
    get   = "true"
    input = "false"
  }
}
