resource "yandex_storage_bucket" "bucket" {
  access_key    = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key    = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket        = local.bucket_name
  max_size      = var.bucket_max_size
  force_destroy = true
  acl           = "public-read"
}

resource "yandex_storage_object" "picture" {
  access_key   = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key   = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket       = local.bucket_name
  key          = local.picture_name
  source       = var.picture_path
  content_type = "image/jpeg"
}
