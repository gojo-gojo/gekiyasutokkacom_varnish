vcl 4.0;

backend default {
  .host = "nginx";
  .port = "80";
  .host_header = "gekiyasutokka.com";
}



sub vcl_recv {
  if (req.http.user-agent) {
      unset req.http.user-agent;
  }
  if (req.method =="PURGE"){
    if (req.http.User-Agent == "test-test") {
      return (purge);
    }else{
      return (synth(405, "Not Allowed"));
    }
  }
  return (hash); # すべてのリクエストをキャッシュ対象にする
}

sub vcl_backend_response {
  if (bereq.url ~"/page/"){
    set beresp.ttl = 300s;
  }else{
    set beresp.ttl = 10d;
  }

  if (beresp.status >=400 ){
    set beresp.ttl = 30s;
  }
}