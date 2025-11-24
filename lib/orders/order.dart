class SubDoc {
  String? title, level, fieldOfStudy, university, company, description, link;
  DateTime? startDate, endDate;
  SubDoc();
  Map<String,dynamic> toJson()=>{
    'title':title,'level':level,'fieldOfStudy':fieldOfStudy,'university':university,
    'company':company,'description':description,'link':link,
    'startDate':startDate?.toIso8601String(),'endDate':endDate?.toIso8601String()
  };
}

class Contact {
  String? fullName,email,phone,linkedin,city,country,highestQualification;
  Map<String,dynamic> toJson()=>{
    'fullName':fullName,'email':email,'phone':phone,'linkedin':linkedin,'city':city,'country':country,'highestQualification':highestQualification
  };
}

class OrderModel {
  String? id,status,deliverableUrl,notes; bool paid=false; double price=10;
  Contact contact = Contact();
  List<SubDoc> education=[], experience=[], skills=[], languages=[], achievements=[], certifications=[], projects=[];
  Map<String,dynamic> toJson()=>{
    'contact':contact.toJson(),'education':education.map((e)=>e.toJson()).toList(),
    'experience':experience.map((e)=>e.toJson()).toList(),
    'skills':skills.map((e)=>e.toJson()).toList(),
    'languages':languages.map((e)=>e.toJson()).toList(),
    'achievements':achievements.map((e)=>e.toJson()).toList(),
    'certifications':certifications.map((e)=>e.toJson()).toList(),
    'projects':projects.map((e)=>e.toJson()).toList(),
    'notes':notes, 'price':price
  };
}