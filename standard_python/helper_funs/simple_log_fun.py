from helper_funs import logger, config
from time import sleep

# define default / global constant
DEFAULT_WAIT_INTERVAL = 3.0

# get setting from config instance safely with a default value
wait_interval = config.getfloat('log', 'wait_interval', fallback=DEFAULT_WAIT_INTERVAL)

# define test function
def test_logger():

    logger.debug('Hello! This is debug log message testing.')

    sleep(wait_interval)

    logger.info('Hello! This is info log message testing.')

    sleep(wait_interval)

    logger.warning('Hello! This is warning log message testing.')

    sleep(wait_interval)

    logger.error('Hello! This is error log message testing.')

    sleep(wait_interval)

    logger.critical('Hello! This is critical log message testing.')
    
    return
