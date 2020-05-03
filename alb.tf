resource "aws_lb" "example" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.allow_tls.id}"]
  subnets            = flatten([aws_subnet.public_one.*.id, aws_subnet.public_two.*.id])
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.example.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-FS-2018-06"
  certificate_arn   = "arn:aws:acm:eu-west-1:781750785623:certificate/4915d617-0f04-450b-975e-d2ea808a2400"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not found"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "https" {
  for_each = var.domain_mappings

  listener_arn = aws_lb_listener.https.arn
  action {
    type = "redirect"
    redirect {
      host        = each.value
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  condition {
    host_header {
      values = [each.key]
    }
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener_rule" "http" {
  for_each = var.domain_mappings

  listener_arn = aws_lb_listener.http.arn
  action {
    type = "redirect"
    redirect {
      host        = each.value
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  condition {
    host_header {
      values = [each.key]
    }
  }
}

resource "aws_lb_listener_certificate" "example" {
  count           = var.certificate_arn != "" ? 1 : 0
  listener_arn    = aws_lb_listener.https.arn
  certificate_arn = var.certificate_arn
}