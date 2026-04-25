variable "student_count" {
  description = "Number of student projects to create"
  type        = number
  default     = 0
}

variable "org_domain" {
  description = "Google Workspace domain"
  type        = string
  default     = "it-erben.com"
}

variable "billing_account" {
  description = "Billing account ID"
  type        = string
  default     = "018B45-B9B02C-7EE48F"
}

variable "trainer_email" {
  description = "Trainer Google account"
  type        = string
  default     = "alex@it-erben.com"
}
