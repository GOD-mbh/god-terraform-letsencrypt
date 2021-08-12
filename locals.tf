# locals.tf

locals {
  namespace  = kubernetes_namespace.this.id
  repository = "https://charts.jetstack.io"
  name       = "cert-manager"
  chart      = "cert-manager"
  version    = "v1.4.0"
  values = concat([
    {
      "name"  = "installCRDs"
      "value" = "true"
    },
    {
      "name"  = "ingressShim.defaultIssuerName"
      "value" = "letsencrypt-prod"
    },
    {
      "name"  = "ingressShim.defaultIssuerKind"
      "value" = "ClusterIssuer"
    },
    {
      "name"  = "ingressShim.defaultIssuerGroup"
      "value" = "cert-manager.io"
    },
    {
      "name"  = "rbac.serviceAccountAnnotations.eks\\.amazonaws\\.com/role-arn"
      "value" = module.iam_assumable_role_admin.iam_role_arn
    },
    {
      "name"  = "aws.region"
      "value" = data.aws_region.current.name
    }
    ],
    values({
      for i, domain in tolist(var.domains) :
      "key" => {
        "name"  = "domainFilters[${i}]"
        "value" = domain
      }
    })
  )
  issuers = {
    "staging" = {
      "apiVersion" = "cert-manager.io/v1alpha2"
      "kind"       = "ClusterIssuer"
      "metadata" = {
        "name" = "letsencrypt-staging"
      }
      "spec" = {
        "acme" = {
          "server" = "https://acme-staging-v02.api.letsencrypt.org/directory"
          "email"  = var.email
          "privateKeySecretRef" = {
            "name" = "letsencrypt-staging"
          }
          "solvers" = [
            {
              "dns01" = {
                "route53" = {
                  "region"       = data.aws_region.current.name
                  "hostedZoneID" = var.zone_id
                }
              }
            }
          ]
        }
      }
    }
    "prod" = {
      "apiVersion" = "cert-manager.io/v1alpha2"
      "kind"       = "ClusterIssuer"
      "metadata" = {
        "name" = "letsencrypt-prod"
      }
      "spec" = {
        "acme" = {
          "server" = "https://acme-v02.api.letsencrypt.org/directory"
          "email"  = var.email
          "privateKeySecretRef" = {
            "name" = "letsencrypt-prod"
          }
          "solvers" = [
            {
              "dns01" = {
                "route53" = {
                  "region"       = data.aws_region.current.name
                  "hostedZoneID" = var.zone_id
                }
              }
            }
          ]
        }
      }
    }
  }
}
