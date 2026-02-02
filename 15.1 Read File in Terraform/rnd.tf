
output "printfile" {
  value = file("${path.module}/rnd.txt")
}

// value = "${path.module}/rnd.txt"
// path.module is a built-in variable that returns the file path of the module where it is used.
// value = file("${path.module}/rnd.txt")
// file() is a built-in function that reads the contents of a file and returns it as a string.