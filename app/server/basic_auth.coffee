if process.env.BASIC_AUTH
  basicAuth = new HttpBasicAuth("kolumbus", "1492")
  basicAuth.protect()
