# ejecutado todos los dias con crontab: 0 12 * * *
# localserver:  python -m smtpd -c DebuggingServer -n localhost:1025

import smtplib
import mimetypes
from email.message import EmailMessage

message = EmailMessage()
message.set_content('Este email contiene adjunto un excel con paises')
message['Subject'] = 'Excel paises'
message['From'] = 'me@example.com'
message['To'] = 'user@example.com'
# message.attach('example.xlsx')

mime_type, _ = mimetypes.guess_type('example.xlsx')
mime_type, mime_subtype = mime_type.split('/', 1)
with open('example.xlsx', 'rb') as ap:
     message.add_attachment(ap.read(), maintype=mime_type, subtype=mime_subtype,
                        filename='example.xlsx')

smtp_server = smtplib.SMTP('localhost:1025')
smtp_server.send_message(message)
smtp_server.quit()