package com.example.courseservice.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class CourseService {

    @Autowired
    private RestTemplate restTemplate;

    private final String URL = "http://localhost:8081/students";

    public Object getStudentData() {
        try {
            return restTemplate.getForObject(URL, Object.class);
        } catch (Exception e) {
            return "Student Service is unavailable";
        }
    }
}