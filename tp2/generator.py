import json
import pandas as pd
from sys import argv
import os

#print the json data to the console and perform minor validation tests
def printConfiguration(data):
    print("Department: %s" % data["department"])

    #print teacher types in a table
    pDTeacherTypes = pd.DataFrame(data["teacherTypes"], columns=["name", "averageWeekHours"])
    pDTeacherTypes.index +=1
    print("\nTeacher types (%d):" % len(pDTeacherTypes))
    print(pDTeacherTypes)

    #print scientific types in a table
    pdFields = pd.DataFrame(data["fields"])
    pdFields.index +=1
    print("\nScientific fields (%d):" % len(pdFields))
    print(pdFields)

    #print teacher information in a table
    pDTeachers = pd.DataFrame(data["teachers"], columns=["name", "type", "field", "Diff"])
    pDTeachers.index +=1
    print("\nTeachers (%d):" % len(pDTeachers))
    print(pDTeachers)

    #print subject information in a table
    pdSubjects = pd.DataFrame(data["subjects"], columns=["name", "semester", "HT", "HP", "DT", "DP", "field"])
    pdSubjects.index +=1
    print("\nSubjects (%d):" % len(data["subjects"]))
    print(pdSubjects)

    #print hours sum summary
    ht = pdSubjects["HT"].sum()
    hp = pdSubjects["HP"].sum()
    print("\n%30s: %4dh" % ("Total Theoretical", ht))
    print("%30s: %4dh" % ("Total Practical", hp))
    #semester 1
    s1 = pdSubjects.query("semester == 1")
    ht1 = s1["HT"].sum()
    hp1 = s1["HP"].sum()
    print("\n%30s: %4dh" % ("Total Theoretical Semester 1", ht1))
    print("%30s: %4dh" % ("Total Theoretical Semester 1", hp1))
    print("%30s: %4dh" % ("Total Semester 1", ht1 + hp1))
    #semester 2
    s2 = pdSubjects.query("semester == 2")
    ht2 = s2["HT"].sum()
    hp2 = s2["HP"].sum()
    print("\n%30s: %4dh" % ("Total Theoretical Semester 2", ht2))
    print("%30s: %4dh" % ("Total Theoretical Semester 2", hp2))
    print("%30s: %4dh" % ("Total Semester 2", ht2 + hp2))

#convert the json data into prolog predicates, with proper comments and format
def convertToProlog(data, filename):
    content = ("%% Autogenerated data file from JSON file: '%s'\n" % filename)

    #print field
    ''' content += "\n% field(Field).\n"
    for field in data["fields"]:
        content += ("%%field(%d). %% %s\n" % (i, field["name"])) '''
    content += "\nfields(%d). %% count fields\n" % len(data["fields"])

    #print subject
    content += "\n% subject(Semester, HT, HP, DT, DP, Field).\n"
    for s in data["subjects"]:
        content += ("subject(%d, %2d, %2d, %d, %d, %2s). %% %s\n" % (s["semester"], s["HT"], s["HP"], s["DT"], s["DP"], s["field"], s["name"]))
    content += "\nsubjects(%d). %% count subjects\n" % len(data["subjects"])

    #print teacher types
    content += "\n% teacherType(Type, AverageWeekHours).\n"
    i = 0
    for t in data["teacherTypes"]:
        i += 1
        content += ("teacherType(%d, %2d). %% %s\n" % (i, t["averageWeekHours"], t["name"]))
    content += "\nteacherTypes(%d). %% count teacher types\n" % len(data["teacherTypes"])

    #print teacher information
    content += "\n% teacher(Type, Diff, Field).\n"
    for t in data["teachers"]:
        content += ("teacher(%d, %2d, %s). %% %s\n" % (t["type"], t["Diff"], t["field"], t["name"]))
    content += "\nteachers(%d). %% count teachers" % len(data["teachers"])
    return content

#write contents to a file, warns if it already exists
def writeFileWarnDuplicate(filename, contents):
    if os.path.isfile(filename):
        print("----[WARNING]: %s already exists, either it was not deleted or our name clear rules had a collison" % filename)
    with open(filename, 'w', encoding="utf-8") as f:#write the new main
        f.write(contents)

def generatePrologForFile(filename, print = False, ouput = "src/data.pl"):
    with open(filename, 'r', encoding="utf-8") as jsonFile:
        data = json.loads(jsonFile.read())
        if print:
            printConfiguration(data)
        dataFile = open(ouput, 'w', encoding="utf-8")
        prologCode = convertToProlog(data, filename)
        dataFile.write(prologCode)
        dataFile.close()

if __name__ == "__main__":
    if len(argv) < 2:
        print("Plog Generator usage is `python %s filename.json`\n" % argv[0])
        exit()
    generatePrologForFile(argv[1], True)
