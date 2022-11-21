
import argparse
import yaml
from yaml.loader import SafeLoader
import re
import os

def parseLayoutFile():
    layoutFile = open(args.layout,"r")
    data = layoutFile.read()
    layoutFile.close()
    regex= r'(?<=\")([\s\S]*?)(?=\")'
    data = re.findall(regex, data)
    if(len(data) != 5):
        raise Exception('layout file has a different structure from expected')
    return [data[0], data[2], data[4]]
 

def parseEventFile():
    eventFile = open(args.event, "r")
    data = yaml.load(eventFile, Loader=SafeLoader)
    eventFile.close()
    return data

def alignMultiLine(characterCounter, multilineString):
    index = 0
    strings = multilineString.split('\n')
    for string in strings:
        if(index !=0):
            string = string.lstrip()
            string = "\n"+"".join(" " for i in range(characterCounter)) + string
            strings[index] = string
        index+=1
    return "\n".join(strings)

def replaceSymbols(text, oldSymbols, newSymbols):
    counter = 0
    for oldSymbol in oldSymbols:
        if(len(newSymbols[counter]) - len(oldSymbols[counter]) > 0):
            text = str(text).replace(oldSymbol, " "+newSymbols[counter]+" ")
        else:
            text = str(text).replace(oldSymbol, newSymbols[counter])
        counter+=1
    return text

def getTitleLength(header):
    idx1 = header.find("<over_score>")+14
    idx2 = header.find("<under_score>")
    return idx2 - idx1

# def getContext(context):
#     if(len(context) == 3):
#         return "starlingx-openstack-empty"
#     elif(len(context) == 2):
#         if("starlingx" in context):
#             if("openstack" in context):
#                 return "starlingx-openstack"
#             else:
#                 return "starlingx-empty"
#         else:
#             return "openstack-empty"
#     else:
#         return context[0]

# RS - 11-16-22 - generalize getContext to all runtime scenarios
def getContext(context):
    return '-'.join(map(str, context))

def seriesFilter(key, serie):
    if(float(serie)%100 > 1):
        return (float(key)//10) == (float(serie)//10)
    else:
        return (float(key)//100) == (float(serie)//100)

def seriesFile(layout, events, types, fileExtension, oldSymbols, newSymbols, products, sort ):
    series = args.series.split(",")
    for serie in series:
        matchingKeys = [key for key in events.keys() if seriesFilter(key, serie) and events[key]["Type"] in types and events[key]["Context"] in products ]
        if(sort):
            matchingKeys.sort()
        if(len(matchingKeys) > 0):
            serieFile = open(args.outputPath+str(serie)+"-series-"+'-'.join(types).lower()+"-messages"+fileExtension, "w")
            header = layout[0]
            header = header.replace("<series_number>",serie).replace("<series-number>",serie)
            score = "".join(args.titleSymbol for i in range(getTitleLength(header)))
            header = header.replace("<over_score>", score)
            header = header.replace("<Context>", getContext(products))
            header = header.replace("<under_score>", score)
            serieFile.write(header)
            for matchingKey in matchingKeys:
                body = layout[1]
                body = body.replace("<alarm_id>", format(matchingKey, '.3f'))
                fields = re.findall('(?<=\<)(.*?)(?=\>)', body)
                for field in fields:
                    if(field in events[matchingKey]):
                        if(type(events[matchingKey][field]) == type(events)):
                            value = []
                            for subkey in events[matchingKey][field]:
                                value.append(events[matchingKey][field][subkey])
                            events[matchingKey][field] = "\n".join(value)
                        else:
                            events[matchingKey][field] = (re.sub(r'\n\s*\n','\n',str(events[matchingKey][field]),re.MULTILINE))
                        if(oldSymbols != None and newSymbols != None):
                            events[matchingKey][field]= replaceSymbols(events[matchingKey][field], oldSymbols,newSymbols)
                        if('\n' in events[matchingKey][field]):
                            index = body.index('<'+field+'>')
                            characterCounter= 0
                            while(body[index] != '\n'):
                                index-=1
                                characterCounter+=1
                            body = body.replace('<'+field+'>',alignMultiLine(characterCounter-1, events[matchingKey][field]))
                        else:
                            body = body.replace('<'+field+'>',events[matchingKey][field])
                    else:
                        body = body.replace('<'+field+'>','N/A')
                serieFile.write(body)
            footer = layout[2]
            serieFile.write(footer)
            serieFile.close

def recordsFile(layout, events, fileExtension, oldSymbols, newSymbols, sort):
    records = args.records.split(",")
    if(len(records) > 0):
        matchingKeys = [float(record) for record in records for key in events.keys() if float(key) == float(record)]
        if(sort):
            matchingKeys.sort()
        if(len(matchingKeys) > 0):
            serieFile = open(args.outputPath+args.fileName+fileExtension, "w")
            header = layout[0]
            score = "".join(args.titleSymbol for i in range(getTitleLength(header)))
            header = header.replace("<over_score>", score)
            header = header.replace("<under_score>", score)
            serieFile.write(header)
            for matchingKey in matchingKeys:
                body = layout[1]
                body = body.replace("<alarm_id>", format(matchingKey, '.3f'))
                fields = re.findall('(?<=\<)(.*?)(?=\>)', body)
                for field in fields:
                    if(field in events[matchingKey]):
                        if(type(events[matchingKey][field]) == type(events)):
                            value = []
                            for subkey in events[matchingKey][field]:
                                value.append(events[matchingKey][field][subkey])
                            events[matchingKey][field] = "\n".join(value)
                        else:
                             events[matchingKey][field] = (re.sub(r'\n\s*\n','\n',str(events[matchingKey][field]),re.MULTILINE))
                        if(oldSymbols != None and newSymbols != None):
                            events[matchingKey][field]= replaceSymbols(events[matchingKey][field], oldSymbols,newSymbols)
                        if('\n' in events[matchingKey][field]):
                            index = body.index('<'+field+'>')
                            characterCounter= 0
                            while(body[index] != '\n'):
                                index-=1
                                characterCounter+=1
                            body = body.replace('<'+field+'>',alignMultiLine(characterCounter-1, events[matchingKey][field]))
                        else:
                            body = body.replace('<'+field+'>',events[matchingKey][field])
                    else:
                        body = body.replace('<'+field+'>','N/A')
                serieFile.write(body)
            footer = layout[2]
            serieFile.write(footer)
            serieFile.close    


parser = argparse.ArgumentParser()
invalidArguments = False 
parser.add_argument("-l", "--layout", required=True, help = "path for the layout file")
parser.add_argument("-e", "--event", required=True, help = "path for the events.yaml file")
parser.add_argument("-s", "--series", help = "list of the desired series")
parser.add_argument("-ts", "--titleSymbol", required=True, help = "Symbol used between the title")
parser.add_argument("-replace", "--replace", required=False, help = "replaces a symbol with another")
parser.add_argument("-type", "--type", help = "type can be Alarm or Log, it also can be both")
parser.add_argument("-outputPath", "--outputPath", required=True, help="Path where the output will be saved")
parser.add_argument("-records", "--records", help="list of the desired records")
parser.add_argument("-fileName", "--fileName", help="file name for the output file")
parser.add_argument("-product", "--product", help="product type for filtering")
parser.add_argument("-sort", "--sort", help="argument that defines if the output will be sorted")


args = parser.parse_args()
oldSymbol = None
newSymbol = None
types = []

if(args.series == None and args.records == None):
    invalidArguments = True
    print("Expected either series or records as an argument")
if(args.series != None and args.product == None):
    invalidArguments = True
    print("Expected product as an argument")
if(args.series != None and args.type == None):
    invalidArguments=True
    print("Expected type as an argument")
if(args.replace != None):
    replaceItems =args.replace.split(",")
    oldSymbols = []
    newSymbols = []
    for replaceItem in replaceItems:
        replace = replaceItem.lstrip().split(" ")
        if(len(replace) == 2):
            oldSymbols.append(replace[0])
            newSymbols.append(replace[1])
if(args.type != None):
    types = args.type.split(",")
    counter = 0
    for recordtype in types:
        types[counter] = recordtype.lstrip().rstrip().capitalize()
        if(types[counter] != "Alarm" and types[counter]!= "Log"):
            invalidArguments = True
            print("Invalid type argument")
        counter +=1
if(args.records != None):
    if(args.fileName == None):
        invalidArguments = True
        print("Expected fileName as an argument")
if(args.product != None):
    products = args.product.split(",")
    counter = 0
    for product in products:
        products[counter] = product.lstrip().rstrip().lower()
        if(products[counter] != "openstack" and products[counter] != "starlingx"):
            if(products[counter] == "empty"):
                products[counter] = None
            else:
                print("Invalid product argument") 
                invalidArguments= True
        counter +=1
if(args.sort != None):
    if(args.sort.upper() == 'TRUE'):
        sort = True
    else:
        sort = False
else:
    sort = False



if(invalidArguments == False):
    fileName, fileExtension = os.path.splitext(args.layout)
    layout = parseLayoutFile()
    events = parseEventFile()
    if(args.records != None):
        recordsFile(layout,events,fileExtension, oldSymbols, newSymbols,sort)
    else:
        seriesFile(layout, events, types, fileExtension, oldSymbols, newSymbols, products,sort)