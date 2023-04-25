
class Employee {
  int? employeeId;
  int? employeeCardno;
  String? employeeName;
  String? designation;
  String? division;
  String? departmentName;
  String? joinDate;
  String? floor;
  String? salarygrp;
  String? sex;
  String? empStatus;
  String? emailAddress;
  String? mobileNo;
  String? firebaseToken;
  String? loginToken;
  int? userId;

  Employee(
      {this.employeeId,
        this.employeeCardno,
        this.employeeName,
        this.designation,
        this.division,
        this.departmentName,
        this.joinDate,
        this.floor,
        this.salarygrp,
        this.sex,
        this.empStatus,
        this.emailAddress,
        this.userId,
        this.firebaseToken,
        this.loginToken,
        this.mobileNo});

  Employee.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id'];
    employeeCardno = json['employee_cardno'];
    employeeName = json['employee_name'];
    designation = json['designation'];
    division = json['division'];
    departmentName = json['department_name'];
    joinDate = json['join_date'];
    floor = json['floor'];
    salarygrp = json['salarygrp'];
    sex = json['sex'];
    empStatus = json['emp_status'];
    emailAddress = json['email_address'];
    mobileNo = json['mobile_no'];
    firebaseToken = json['firebase_token'];
    loginToken = json['login_token'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employee_id'] = this.employeeId;
    data['employee_cardno'] = this.employeeCardno;
    data['employee_name'] = this.employeeName;
    data['designation'] = this.designation;
    data['division'] = this.division;
    data['department_name'] = this.departmentName;
    data['join_date'] = this.joinDate;
    data['floor'] = this.floor;
    data['salarygrp'] = this.salarygrp;
    data['sex'] = this.sex;
    data['emp_status'] = this.empStatus;
    data['email_address'] = this.emailAddress;
    data['mobile_no'] = this.mobileNo;
    data['user_id'] = this.userId;
    data['firebase_token'] = this.firebaseToken;
    data['login_token'] = this.loginToken;
    return data;
  }
}