package PRJG5.backend.spring.db;
import PRJG5.backend.spring.model.Student;

import java.util.List;
import java.util.Optional;

import org.springframework.data.repository.CrudRepository;

public interface StudentDB extends CrudRepository<Student,Long> {
    List<Student> findAllByOrderByStudentIdAsc();
    Optional<Student> findByStudentId(String studentId);
}
   
