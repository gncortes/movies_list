
# Movies List

Este projeto Flutter exibe informações sobre filmes, como anos com múltiplos vencedores, estúdios com mais vitórias, intervalos de prêmios e busca de filmes por ano. A interface foi desenvolvida com foco na simplicidade e reatividade, utilizando `ValueNotifier` e `switch case` para gerenciamento de estado, proporcionando uma experiência de usuário fluida e responsiva.

## Estrutura do Projeto

O projeto segue uma arquitetura em camadas que facilita a manutenção e extensão:

- **Data Layer**: Responsável por acessar os dados, utilizando `IMoviesDatasource` e sua implementação `MoviesDatasource`.
- **Domain Layer**: Contém as entidades principais, como `MovieEntity` e `YearEntity`, definindo a lógica de negócios do domínio.
- **Presentation Layer**: Gerencia o estado da interface do usuário (UI) usando `ValueNotifier`, que simplifica o re-render da tela sempre que há mudança nos dados, sem a necessidade de pacotes de gerenciamento de estado mais complexos.

## Gerenciamento de Estado com ValueNotifier e switch case

A UI é gerenciada com `ValueNotifier`, um método simples e eficiente para atualizar o estado e garantir que a interface reaja corretamente a mudanças de dados. Isso é feito por meio de `ValueListenableBuilder`, que reconstrói a UI toda vez que o valor do `ValueNotifier` muda.

### Exemplo de switch case

Na tela principal (`DashboardPage`), o estado da tela é atualizado dinamicamente com base no estado atual do `ValueNotifier`. O `switch case` torna o código mais legível e organizado, associando diretamente os diferentes estados às respectivas ações e widgets na UI.

#### Código de Exemplo

Aqui está um exemplo de como `switch case` é usado em conjunto com o `ValueNotifier` para definir os estados da interface:

```dart
      appBar: AppBar(
        centerTitle: true,
        title: ValueListenableBuilder<DashboardComponentState>(
          valueListenable: controller.selectedComponentNotifier,
          builder: (context, state, _) {
            return Text(
              switch (state) {
                ShowYearsState() => 'Anos com Mais de um Vencedor',
                ShowStudiosState() => 'Estúdios com Mais Vitórias',
                ShowProducerIntervalState() =>
                  'Intervalo de Prêmios dos Produtores',
                ShowMoviesByYearSearchState() => 'Pesquisar Filmes por Ano',
                _ => 'Selecione uma Opção',
              },
            );
          },
        ),
      ),
```

### Benefícios do Uso do switch case

1. **Clareza**: Cada estado tem um caso específico, facilitando a leitura e o entendimento de como a UI reage a diferentes eventos.
2. **Manutenção**: Novos estados podem ser facilmente adicionados sem a necessidade de modificar a estrutura principal da tela.
3. **Reutilização**: Widgets como `Text`, que é usado para exibir o título da `AppBar`, podem ser facilmente reutilizados em outros estados, dentro do mesmo `ValueListenableBuilder`. O mesmo vale para outros componentes, como `YearCard`, `CustomErrorWidget` e `MoviesSearchWidget`, que podem ser vinculados a diferentes estados e exibidos conforme a lógica definida no `switch case`.

### Exemplo de Valor Notificável

Aqui está um exemplo de como o `ValueNotifier` é implementado para gerenciar o estado de busca de anos com múltiplos vencedores:

```dart
class YearsNotifier extends ValueNotifier<DashboardYearsState> {
  YearsNotifier() : super(DashboardYearsLoadingState());

  Future<void> fetch(Future<Either<CustomError, List<YearEntity>>> Function() fetchYears) async {
    value = DashboardYearsLoadingState();
    final result = await fetchYears();
    result.fold(
      (error) => value = DashboardYearsErrorState(error: error),
      (yearsData) => value = DashboardYearsSuccessState(years: yearsData),
    );
  }
}
```

## Testes

Os testes garantem que o projeto funciona corretamente ao realizar ações como buscar dados, lidar com erros e atualizar a UI de acordo. Eles simulam diferentes cenários para verificar se o comportamento esperado ocorre.

### Exemplo de Teste de Erro

```dart
test('should set error state when fetching movies fails', () async {
    when(mockDatasource.getMoviesByYearPagined(
    testYear,
    page: page,
    size: size,
    winner: winner,
    )).thenAnswer((_) async => Left(DefaultException().error));

    await controller.getMoviesByYear(testYear);

    expect(mockNotifier.value, isA<MoviesErrorState>());
    expect(
    (mockNotifier.value as MoviesErrorState).error.message,
    'Aconteceu um erro inesperado',
    );
});
```

## Principais Testes

- Sucesso ao buscar dados de filmes por ano.
- Falha ao buscar dados, retornando estado de erro.
- Mudança de estado da UI com base no retorno de dados.

## Conclusão

O uso de `ValueNotifier` e `switch case` simplifica o gerenciamento de estado na camada de apresentação. A arquitetura em camadas mantém o código organizado e testável, facilitando a escalabilidade do projeto. O design também promove a clareza e a manutenção do código, tornando-o acessível para desenvolvedores que precisam introduzir novas funcionalidades ou corrigir bugs rapidamente.

---

Com essa abordagem, sua aplicação garante uma UI mais dinâmica e reativa, além de ser fácil de manter e testar.

## Como Executar o Projeto

1. Verifique se o Flutter está instalado corretamente.
2. No diretório raiz do projeto, execute:

```bash
flutter run
```

## Rodar os Testes

Execute o comando abaixo para rodar os testes:

```bash
flutter test
```