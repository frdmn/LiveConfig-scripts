# LiveConfig-scripts/confixx_web_and_mail_data_migrate

## Installation

1. Adjust the settings:  
  `cp /usr/local/src/liveconfig-scripts/confixx_web_and_mail_data_migrate/settings.conf.example /usr/local/src/liveconfig-scripts/confixx_web_and_mail_data_migrate/settings.conf`   
  `vi /usr/local/src/liveconfig-scripts/confixx_web_and_mail_data_migrate/settings.conf`   

## Usage / How to

#### Mailbox content migration (migrate-mail.sh)

1. Make sure to update the mail account mapping (Confixx <-> LiveConfig):  
  `vi /usr/local/src/liveconfig-scripts/confixx_web_and_mail_data_migrate/mail.log`    
2. Run the mailbox migration script:
  `/usr/local/src/liveconfig-scripts/confixx_web_and_mail_data_migrate/migrate-mail.sh`  
3. Check logs to ensure no issues / failure happend.

#### Web server content migration (migrate-web.sh)

1. Run the web migration script:
  `/usr/local/src/liveconfig-scripts/confixx_web_and_mail_data_migrate/migrate-web.sh`  
2. Answer all interactive questions/prompts.
3. Check logs to ensure no issues / failure happend.
