#!/usr/bin/env python
# -*- coding: utf-8 -*-
import urllib2, re, json

USERNAME='XXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
FROM_NAME='XXXXXXXXXXXXXXXXXX'
PASSWORD='XXXXXXXXXXXXXXXXXX'
DESTINATION='XXXXXXXXXXXXXXXXXXXXXXX'

SUBJECT="Bajada de precio de '{name}'"
BODY='''El precio de '{name}' ha bajado del valor solicitado ({threshold}€): {price}€

Dirección: {url}
'''

SUBJECT_CHG="Cambio de precio de '{name}'"
BODY_CHG='''El precio de '{name}' ha cambiado de {oldPrice}€ a {price}€

Dirección: {url}
'''


products = [
        {'url': "https://www.pccomponentes.com/crucial-mx500-ssd-250gb-sata", 'threshold': 160},
        {'url': "https://www.pccomponentes.com/crucial-bx500-ssd-240gb-3d-nand-sata3", 'threshold': 160}
        
        {'url': "https://www.pccomponentes.com/samsung-860-evo-basic-ssd-250gb-sata3", 'threshold': 156},
        {'url': "http://www.redcoon.es/B581911-Samsung-850-Evo-Series-500GB-Basic_SSD-hasta-25", 'threshold': 156},

        {'url': "http://www.pccomponentes.com/crucial_bx_100_ssd_500gb.html", 'threshold': 149},
        {'url': "http://www.redcoon.es/B581610-Crucial-BX100-500GB_SSD-hasta-25", 'threshold': 149},

        {'url': "http://www.pccomponentes.com/crucial_mx200_500gb_ssd.html", 'threshold': 172},
        {'url': "http://www.redcoon.es/B581614-Crucial-MX200-500GB_SSD-hasta-25", 'threshold': 172},
        
        
        {'url': "http://www.pccomponentes.com/lg_50lf5800_50__led.html", 'threshold': 599},
        {'url': "http://www.redcoon.es/B591403-LG-50LF5800_TV-LED", 'threshold': 599},
]

def send_email(user, pwd, recipient, subject, body):
    import smtplib

    gmail_user = user
    gmail_pwd = pwd
    FROM = user
    TO = recipient if type(recipient) is list else [recipient]
    SUBJECT = subject
    TEXT = body

    # Prepare actual message
    message = """From: %s <%s>\nTo: %s\nSubject: %s\n\n%s
    """ % (FROM_NAME, FROM, ", ".join(TO), SUBJECT, TEXT)
    try:
        server = smtplib.SMTP("smtp.gmail.com", 587)
        server.ehlo()
        server.starttls()
        server.login(gmail_user, gmail_pwd)
        server.sendmail(FROM, TO, message)
        server.close()
        #print 'successfully sent the mail'
    except:
        #print "failed to send mail"
        pass

def priceChecker(url):
    ua = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.99 Safari/537.36"
    headers = { 'User-Agent' : ua }
    web = urllib2.urlopen(urllib2.Request(url, headers = headers)).read()
    priceSearch = re.search("(?:productName|'name'): ['\"](?P<name>.+?)['\"].*?'?price'?: ['\"](?P<price>\d+)", web, re.DOTALL | re.MULTILINE)

    if priceSearch:
        return priceSearch.group('name'), int(priceSearch.group('price'))
    else:
        raise LookupError("Price not found in: {0}".format(url))

def checkProduct(product):
    url, threshold = product['url'], product.setdefault('threshold', 0)
    try:
        name, price = priceChecker(url)
    except Exception as e:
        send_email(USERNAME, PASSWORD, DESTINATION, "[Raspberry] Price tracker error", "Error processing {0}\n\nException: {1}".format(url, e))
    else:
        oldPrice = oldPrices.get(url)
        if oldPrice and oldPrice != price:
            fields = { 'name': name, 'price': price, 'oldPrice': oldPrice}
            fields.update(product)
            send_email(USERNAME, PASSWORD, DESTINATION, SUBJECT_CHG.format(**fields), BODY_CHG.format(**fields))

            if price <= threshold:
                send_email(USERNAME, PASSWORD, DESTINATION, SUBJECT.format(**fields), BODY.format(**fields))
        return {url: price}

FILE="/home/osmc/.priceTracker"

oldPrices = {}
try:
    with open(FILE, "r") as f:
        oldPrices = json.load(f)
except Exception as e:
    print e
    pass

#for product in products:
#    checkProduct(product)

import multiprocessing as mp
pool = mp.Pool(processes=3)

newPrices = {}
prices = pool.map(checkProduct, products)

for price in prices:
    newPrices.update(price)

try:
    with open(FILE, "w+") as f:
        json.dump(newPrices, f, indent = 4)
except Exception as e:
    print e
    pass

