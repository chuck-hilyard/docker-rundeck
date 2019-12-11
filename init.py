import http.client
import os
import requests
import subprocess
import time
import consul_kv
import pwd, grp
import re

def run_app():
  subprocess.run(["service", "rundeckd", "start"])

def is_consul_up():
  url = "http://consul.base.dev.usa.media.reachlocalservices.com:8500/v1/catalog/service/rundeck"
  try:
    response = requests.get(url)
  except requests.exceptions.ConnectionError as ce:
    print("connection error", ce)
  except Exception as ex:
    print("default exception", type(ex))
  else:
    return response.status_code

def main():
  while True:
    print("main loop")
    if is_consul_up() == 200:
      print("consul is up")
    else:
      print("consul is down")
    time.sleep(60)

if __name__ == '__main__':
  #run_app()
  main()
