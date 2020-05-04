resource "aws_globalaccelerator_accelerator" "example" {
  name            = "apex-domain-redirect"
  ip_address_type = "IPV4"
  enabled         = true
}

resource "aws_globalaccelerator_listener" "https" {
  accelerator_arn = aws_globalaccelerator_accelerator.example.id
  protocol        = "TCP"

  port_range {
    from_port = 443
    to_port   = 443
  }
}

resource "aws_globalaccelerator_endpoint_group" "https" {
  listener_arn = aws_globalaccelerator_listener.https.id

  endpoint_configuration {
    endpoint_id = aws_lb.example.arn
    weight      = 100
  }
}

resource "aws_globalaccelerator_listener" "http" {
  accelerator_arn = aws_globalaccelerator_accelerator.example.id
  protocol        = "TCP"

  port_range {
    from_port = 80
    to_port   = 80
  }
}

resource "aws_globalaccelerator_endpoint_group" "http" {
  listener_arn = aws_globalaccelerator_listener.http.id

  endpoint_configuration {
    endpoint_id = aws_lb.example.arn
    weight      = 100
  }
}
