package PRJG5.backend.spring.restcontroller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;


import PRJG5.backend.spring.model.Student;
import PRJG5.backend.spring.service.StudentService;

@CrossOrigin(origins = {
        "https://esiattendancefrontend.azurewebsites.net",
        "http://localhost:5173"
})
@RestController
@RequestMapping("/api")
public class StudentController {

    @Autowired
    private StudentService service;

    @GetMapping("/students")
    public Iterable<Student> getAllTasks() {
        Iterable<Student> students = service.getAllStudents();
        return students;
    }

    @PostMapping("/add/student")
    public Student addStudent(@RequestBody Student student) {
        return service.addStudent(student);
    }

    @DeleteMapping("/delete/student/{studentId}")
    public void deleteStudent(@PathVariable String studentId) {
        service.deleteStudent(studentId);
    }

}
