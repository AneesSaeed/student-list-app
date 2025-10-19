package PRJG5.backend.spring.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import PRJG5.backend.spring.db.StudentDB;
import PRJG5.backend.spring.model.Student;

@Service
public class StudentService {

    @Autowired
    private  StudentDB studentDB;

    public Iterable<Student> getAllStudents(){
        return studentDB.findAllByOrderByStudentIdAsc();
    }


    public Student addStudent(Student student) {
        return studentDB.save(student);
    }

    public void deleteStudent(String studentId) {
    Student student = studentDB.findByStudentId(studentId)
        .orElseThrow(() -> new RuntimeException("Student not found: " + studentId));
    studentDB.delete(student);
}

}
