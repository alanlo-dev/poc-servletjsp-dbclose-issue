package com.staffattendance.model;

import java.text.SimpleDateFormat;
import java.util.Date;

public class AttendanceRecord {
    private int id;
    private int staffId;
    private String staffName;
    private Date checkInTime;
    private Date checkOutTime;
    private String status; // CHECKED_IN or CHECKED_OUT

    public AttendanceRecord() {
    }

    public AttendanceRecord(int id, int staffId, String staffName, Date checkInTime, Date checkOutTime, String status) {
        this.id = id;
        this.staffId = staffId;
        this.staffName = staffName;
        this.checkInTime = checkInTime;
        this.checkOutTime = checkOutTime;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getStaffId() {
        return staffId;
    }

    public void setStaffId(int staffId) {
        this.staffId = staffId;
    }

    public String getStaffName() {
        return staffName;
    }

    public void setStaffName(String staffName) {
        this.staffName = staffName;
    }

    public Date getCheckInTime() {
        return checkInTime;
    }

    public String getFormattedCheckInTime() {
        if (checkInTime == null) return "-";
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return sdf.format(checkInTime);
    }

    public void setCheckInTime(Date checkInTime) {
        this.checkInTime = checkInTime;
    }

    public Date getCheckOutTime() {
        return checkOutTime;
    }

    public String getFormattedCheckOutTime() {
        if (checkOutTime == null) return "-";
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return sdf.format(checkOutTime);
    }

    public void setCheckOutTime(Date checkOutTime) {
        this.checkOutTime = checkOutTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}