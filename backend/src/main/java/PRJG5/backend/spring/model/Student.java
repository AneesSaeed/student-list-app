package PRJG5.backend.spring.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Data;

@Entity
@Data
public class Student {
  @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @Column(name="student_id", nullable=false, unique=true)
  private String studentId;

  @Column(name="last_name", nullable=false)
  private String lastName;

  @Column(name="first_name", nullable=false)
  private String firstName;
}
