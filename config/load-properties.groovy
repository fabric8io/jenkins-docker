import jenkins.model.Jenkins
import java.util.logging.LogManager

def logger = LogManager.getLogManager().getLogger("")

/* JENKINS_HOME environment variable is not reliable */
def jenkinsHome = Jenkins.instance.getRootDir().absolutePath

def propertiesFile = new File("${jenkinsHome}/jenkins.properties")

if (propertiesFile.exists()) {
    logger.info("Loading system properties from ${propertiesFile.absolutePath}")
    propertiesFile.withReader { r ->
        /* Loading java.util.Properties as defaults makes empty Properties object */
        def props = new Properties()
        props.load(r)
        props.each { key, value ->
            System.setProperty(key, value)
        }
    }
}