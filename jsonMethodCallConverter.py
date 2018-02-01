'''
Takes in an array of Json objects, and converts them into method calls.

Json example for a single bean:
{
    "bean": "beanName",
    "aliases": [],
    "scope": "singleton",
    "type": "com.demo.config.BeanType$$EnhancerBySpringCGLIB$$fd1aa276",
    "resource": "URL [<path-to-config>/BeanClass.class]",
    "dependencies": []
}

End result code:
methodName(configs, "beanName", [], "singleton", "com.demo.config.BeanType", BeanClass, [])
'''

from collections import OrderedDict
import re
import json

class DictConverter(object):
    def dictConverter(self, dict):
        beanList = []

        beanList.append(dict["bean"])
        beanList.append(dict["aliases"])
        beanList.append(dict["scope"])
        # strip sub strings starting with $
        beanList.append((dict["type"]).split("$")[0].strip())

        # get only the class name for "resource" if "resource" is not null
        if dict["resource"] != "null":
            r = re.compile('/(.*?).class]')
            oldStr = dict["resource"]
            k = oldStr.rfind("/")
            newStr = oldStr[k:]
            m = r.search(newStr)
            beanList.append(m.group(1))
        else:
            beanList.append("null")

        beanList.append(dict["dependencies"])

        convResult = "methodName(configs,"

        for item in beanList:
            convResult += ' %r,' % item

        convResult = convResult[:-1]
        convResult += ")"
        convResult = convResult.replace("'", '"')

        f = open("convertedBeans.txt", "a")
        f.write(convResult + "\n")
        f.close()

dictArray = [{
				"bean": "bean1",
				"aliases": [],
				"scope": "singleton",
				"type": "com.demo.stuff.BeanType$$EnhancerBySpringCGLIB$$38199deb",
				"resource": "null",
				"dependencies": []
			}, {
				"bean": "org.springframework.boot.autoconfigure.internalCachingMetadataReaderFactory",
				"aliases": [],
				"scope": "singleton",
				"type": "org.springframework.core.type.classreading.CachingMetadataReaderFactory",
				"resource": "null",
				"dependencies": []
			}, {
				"bean": "bean2",
				"aliases": [],
				"scope": "singleton",
				"type": "com.demo.stuff.BeanType",
				"resource": "URL [jar:file:/path!/BOOT-INF/lib/build-version.jar!/com/demo/duh/xxx/BeanClass.class]",
				"dependencies": []
			}
		]

# only convert ones that have keyword in 'type' or 'resource', and no 'AutoConfiguration' or 'PostProcessor' in 'type'
for dict in dictArray:
    if (("keywordzzz" in dict["type"]) or ("keywordzzz" in dict["resource"])) and (
        "AutoConfiguration" not in dict["type"]) and ("PostProcessor" not in dict["type"]):
        list = DictConverter()
        list.dictConverter(dict)
