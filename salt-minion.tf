resource "template_file" "salt-minion" {
  template = "${file("user_data.tpl")}"
  vars {
    hostname             = "salt-minion"
    fqdn                 = "salt-minion.local"
    role                 = "salt-minion"
    env                  = "${var.env}"
    salt_master          = "${var.salt_master}"
  }
}

resource "aws_instance" "salt-minion" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  user_data     = "${template_file.salt-minion.rendered}"
  key_name      = "${var.key_name}"
}
