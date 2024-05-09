from time import tzset
import os
import logging
import colorlog
import configparser
import sys

#######################
## load env and init ##
#######################

# load env variable
LOG_LEVEL = os.environ.get('LOG_LEVEL', 'DEFAULT')

# define default / global constant
# config path # NOTE: use config path in container
CONFIG_PATH = "/config/general.ini" 

# set time zone according to env variable 'TZ' see .env file
tzset()

#########################
## color logger define ##
#########################

# Handler for logging
handler = colorlog.StreamHandler()
formatter = colorlog.ColoredFormatter(
    "%(log_color)s%(asctime)s.%(msecs)03d - %(levelname)s - [%(funcName)s] - %(message)s",
    datefmt='%Y-%m-%d %H:%M:%S',
    log_colors={
        'DEBUG': 'cyan',
        'INFO': 'green',
        'WARNING': 'yellow',
        'ERROR': 'red',
        'CRITICAL': 'red,bg_white',
    }
)
handler.setFormatter(formatter)

# Logger instance
logger = colorlog.getLogger(__name__)
logger.addHandler(handler)

# Logger level
LOG_LEVEL_OPTION = {
    'DEBUG': logging.DEBUG,
    'INFO': logging.INFO,
    'WARNING': logging.WARNING,
    'ERROR': logging.ERROR,
    'CRITICAL': logging.CRITICAL,
    'DEFAULT': logging.INFO
}
logger.setLevel(LOG_LEVEL_OPTION.get(LOG_LEVEL.upper(), 'DEFAULT'))

########################
## config file loader ##
########################
# Initialize the ConfigParser
config = configparser.ConfigParser()
# Read the config file
if os.path.exists(CONFIG_PATH):
    try:
        config.read(CONFIG_PATH)
        logger.info(f"Config file {CONFIG_PATH} successfully loaded.")
    except configparser.Error as e:
        logger.error(f"Error reading the config file {CONFIG_PATH}: {e}")
        sys.exit(1)
else:
    logger.error(f"Config file {CONFIG_PATH} not found")
    sys.exit(1)

#########################
##  import helper funs ##
#########################

# import helper funs
from .simple_log_fun import test_logger
