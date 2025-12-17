module "b2_buckets" {
  source = "../../modules/b2-bucket"

  for_each = var.buckets

  bucket_name               = each.key
  public                    = each.value.public
  days_to_keep_old_versions = each.value.days_to_keep_old_versions
  region                    = each.value.region
  tags                      = each.value.tags
}