###############
#certificate module creates certificate for the domain
###############


#########################
#create certificate for API
########################

#request the certificate
resource "aws_acm_certificate" "domain_cert" {
  domain_name       = var.sub_domain
  validation_method = "DNS"

  tags = {
    env = var.env
  }

  lifecycle {
    create_before_destroy = true
  }
}

#validate certificate

#get the domain hosted zone
data "aws_route53_zone" "domain_zone" {
  name         = var.domain
  private_zone = false
}

#record validation options of the certificate on route 53 as we choose the validation method = "DNS"
resource "aws_route53_record" "record_options" {
  for_each = {
    for dvo in aws_acm_certificate.domain_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.domain_zone.zone_id
}

#finally validate that records is recorded and validate the certificate
resource "aws_acm_certificate_validation" "domain_cert_validate" {
  certificate_arn         = aws_acm_certificate.domain_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.record_options : record.fqdn]
}

