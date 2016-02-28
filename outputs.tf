output "salt_minion_private_ip" {
    value = "${aws_instance.salt-minion.private_ip}"
}

output "salt_minion_public_ip" {
    value = "${aws_instance.salt-minion.public_ip}"
}
