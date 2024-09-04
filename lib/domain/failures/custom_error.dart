class CustomError {
  final String message;

  const CustomError({
    this.message = 'Aconteceu um erro desconhecido',
  });

  factory CustomError.emptyList() {
    return const CustomError(message: 'Ainda não há nada para mostrar aqui');
  }
}
