output "teacher_project_id" {
  value = google_project.teacher.project_id
}

output "student_project_ids" {
  value = google_project.student[*].project_id
}

output "folder_id" {
  value = google_folder.training.name
}
