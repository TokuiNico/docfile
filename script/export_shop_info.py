#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
    Need to create a virtualenv and install panas related plugins
"""


from mosql.db import all_to_dicts
from mosql.util import in_operand
import csvkit
import pandas as pd
import os
import re

from pinkoi.models.Payment import Payment
from pinkoi.models2.base import db02 as db
from pinkoi.lib import json
from pinkoi import g
from pinkoi.display import renderBill


ILLEGAL_CHARACTERS_RE = re.compile(r'[\000-\010]|[\013-\014]|[\016-\037]')

g.LOCALE = g.LANG = 'zh_TW'
g.GEO = 'TW'
g.CURRENCY = 'TWD'

START_DELTA = -15
END_DELTA = -4


SID_LIST_STR = '''\
alto
bagcom
bangstree
bigbite
bits-studio
bonbonstickers
buywowpup
cakehoney
carolpaintbox
carpenterdesign
chambery-cookies
chuyuculture
comma
coucoubird
crystalhung
csodo
dailylike
damu
daughter
dawoodesign
decorh
dessin
dimanche
doggysweets
drizzle-pillow
eyecandle
fama
fanbubao
fandol
forestnoodles
forestwud
fungusgirl
gandandesign
ghostshop
goodluckcookie
hairmo
hand-in-hand
happywood
huadabii
ibaobao
inblooom
inkfool
iohll
ithinking
its-jewelry
janeonepiece
jielin
jkzakka-tw
kenart
kerkerland
kikusui
kokomu
komikuz
ladolcevita
leatai-diary
loidesign
lonelyplanet
loopy
macaron-toe
magais
maostudio
maureencarnival
moremoretoe
mrgoat
msa-glass
mshowfan
mu-chen
mu-zhi-bu
ningoo
onor
people
pinkoi
pion
planddo
plantsinmotion
qmono
qualy
raw-ecoproject
rewen-shop
riche
sajor
san-he
sha-z
simplewarm
soapenny
sonoelefante
southgate
starlululu
sumi
surprise
sweetsecret
tbonestudio
the-think
thirteen-woodworking
tuckshop
turbid-river
unsimple-life
urburb
volcano
wawu
xiuxiubear
yohand
youarealittlebitsour
zhu-handcrafted
zoeshop-handmade'''

SIDS = SID_LIST_STR.split('\n')
DIR = 'export_for_nta'

def run():
    if not os.path.isdir(DIR):
        os.mkdir(DIR)

    csvf = open('{}/info.csv'.format(DIR), 'wb')

    csvw = csvkit.writer(csvf)
    csvw.writerow([
        u'設計館帳號',
        u'設計館名稱',
        u'公司名稱 / 姓名',
        u'統編 / 身分證',
        u'地址',
        u'電話',
        u'email',
        u'收款戶名',
        u'收款銀行名稱',
        u'收款帳號',
    ])

    with db as cur:
        cur.execute('''
            select
                sid,
                name,
                contact_tel,
                contact_mobile,
                identity,
                identity_type,
                payment_info,
                receipt_setting,
                finance_email
            from shop
            where
                sid in {}
        '''.format(in_operand(SIDS))),

        rows = list(cur)

    for (
        sid,
        name,
        contact_tel,
        contact_mobile,
        identity,
        identity_type,
        payment_info,
        receipt_setting,
        finance_email
    ) in rows:

        payment_info = json.loads(payment_info) if payment_info else {}
        receipt_setting = json.loads(receipt_setting) if receipt_setting else {}

        # 設計館名稱
        name_d = json.loads(name)

        # get 身分證號碼, 發票抬頭名稱, 地址
        nationalid = identity
        title = receipt_setting.get('title', '')
        address = receipt_setting.get('address', '')

        # get 銀行*
        bank_name_n_code = ''
        bank_account = ''
        bank_account_name = ''

        payment_method = payment_info.get('payment_method')

        if payment_method == 'atm':

            bank_code = payment_info['bank']
            bank_name = Payment.TW_BANK_MAP.get(bank_code, '')
            if bank_name:
                bank_name_n_code = u'{} ({})'.format(bank_name, bank_code)

            bank_account = payment_info['account']
            bank_account_name = payment_info['name']

        csvw.writerow([
            sid,
            name_d.get('zh_TW', name_d.get('en', '')),
            title,
            nationalid,
            address,
            contact_tel or contact_mobile or '',
            finance_email,
            bank_account_name,
            bank_name_n_code,
            bank_account
        ])

        if not os.path.isfile('{}/{}_201701-201712.xlsx'.format(DIR, sid)):
            export_bill(sid)

    csvf.close()

def export_bill(sid):
    writer = pd.ExcelWriter('{}/{}_201701-201712.xlsx'.format(DIR, sid))
    for delta in range(START_DELTA, END_DELTA+1):
        html = ILLEGAL_CHARACTERS_RE.sub(r'', renderBill(sid, delta))
        dfs = pd.read_html(html)
        start_row = 0
        sheet_name = '{}_2017{}'.format(sid, str(delta + 16).zfill(2))

        for df in dfs:
            df.to_excel(writer, sheet_name=sheet_name,  startrow=start_row, header=False, index=False)
            start_row += len(df)+2
    writer.save()


if __name__ == '__main__':
    run()
