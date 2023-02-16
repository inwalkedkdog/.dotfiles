import sys
import email
from email.Errors import BoundaryError, HeaderParseError
from mailbox import Maildir
 
maildir = sys.argv[1]
 
md = Maildir(maildir, email.message_from_file)
 
while True:
    try:
        mail = md.next()
    except (BoundaryError, HeaderParseError):
        continue
    if mail is None:
        break
    print mail.as_string(True)
