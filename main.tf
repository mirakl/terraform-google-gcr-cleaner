resource "null_resource" "hello_word" {
  provisioner "local-exec" {
    command = var.hello_world
  }
}
