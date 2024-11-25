resource "aws_ecr_repository" "repo" {
  name = "mtg-bans/api"
}

resource "aws_ecr_lifecycle_policy" "repo_policy" {
  repository = aws_ecr_repository.repo.name
  policy     = file("${path.module}/policy.json")
}
