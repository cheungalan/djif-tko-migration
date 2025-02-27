locals {
  default_tags = {
    bu          = var.TagBU
    owner       = var.TagOwner
    environment = var.TagEnv
    product     = var.TagProduct
    component   = var.TagComponent
    servicename = var.TagServiceName
    created_by  = "AWS-CloudOps@dowjones.com"
  }

  default_tags_dist_admin = merge(
    local.default_tags,
    {
      appid    = "in_newswires_djnews_cas"
      preserve = "true"
    }
  )

  default_tags_jls_wrweb = merge(
    local.default_tags,
    {
      appid    = "in_newswires_web_jlswireryter"
      preserve = "true"
    }
  )

  default_tags_rc_web = merge(
    local.default_tags,
    {
      appid    = "in_platform_randc_datagenjapan"
      preserve = "true"
    }
  )

  default_tags_cas_admin = merge(
    local.default_tags,
    {
      appid    = "in_newswires_djnews_cas"
      preserve = "true"
    }
  )

  default_tags_cas_web = merge(
    local.default_tags,
    {
      appid    = "in_newswires_djnews_cas"
      preserve = "true"
    }
  )

  default_tags_jwr_web = merge(
    local.default_tags,
    {
      appid    = "in_newswires_web_jlswireryter"
      preserve = "true"
    }
  )

  default_tags_rnc_archive = merge(
    local.default_tags,
    {
      appid       = "in_platform_randc_datagenjapan"
      preserve    = true
    }
  )

  default_tags_rnc_web = merge(
    local.default_tags,
    {
      appid    = "in_platform_randc_datagenjapan"
      preserve = "true"
    }
  )

  default_tags_cls_web = merge(
    local.default_tags,
    {
      appid    = "in_newswires_djnews_clsdist"
      preserve = "true"
    }
  )

  default_tags_ennews = merge(
    local.default_tags,
    {
      appid       = "djcs_edttools_web_cwsjenews"
      bu          = "djcs"
      product     = "wsj"
      component   = "web"
      servicename = "djcs/wsj/web"
    }
  )

  default_tags_wsj_asia = merge(
    local.default_tags,
    {
      appid       = "djcs_wsj_web_wsja"
      bu          = "djcs"
      product     = "wsj"
      component   = "web"
      servicename = "djcs/wsj/web"
    }
  )

}
