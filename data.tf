data "external" "env_vars" {
  program = ["${path.module}/files/env.sh"]
}
