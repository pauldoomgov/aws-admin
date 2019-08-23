resource "aws_guardduty_detector" "master-tts" {
  enable = "${var.aws_guardduty_enabled}"
}
