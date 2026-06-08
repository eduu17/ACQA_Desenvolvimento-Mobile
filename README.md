# ACQA DESENVOLVIMENTO PARA DISPOSITIVOS MÓVEIS


**Curso:** Analise e Desenvolvimento de Sistemas 
**Matéria:** DESENVOLVIMENTO PARA DISPOSITIVOS MÓVEIS 
**Projeto:** Agenda ACQA - Aplicativo de calendario e tarefas  
**Tecnologias utilizadas:** Dart, Flutter e Material Design 3  
**Autor:** Eduardo Sampaio
**RA:** 1135673    
**Link do repositorio:** https://github.com/eduu17/ACQA_Desenvolvimento-Mobile

<img src="https://github.com/eduu17/ACQA_Desenvolvimento-Mobile/blob/main/Images/acqa.png" alt="Telas do Aplicativo">   

## 1. Introdução

Este relatório descreve o desenvolvimento do aplicativo Agenda ACQA, criado para atender aos requisitos da Avaliação Continuada de Questão Aberta. A proposta era desenvolver um projeto em Flutter com tela de login/cadastro, calendáriocalendário, lista de tarefas, cadastro de novas tarefas, remoção e marcaçãoremoçãomarcação de tarefas como concluídas.

Este foi meu primeiro contato prático com Dart e Flutter, então o desenvolvimento também funcionou como uma forma de aprender a estrutura da linguagem e a maneira como o Flutter monta interfaces. No início, a parte mais diferente para mim foi entender que praticamente tudo no Flutter é um widget: textos, botões, telas, espaçamentos, formulários e até estruturas visuais mais complexas.

O aplicativo não utiliza Firebase, pois a atividade permitia que a autenticação fosse apenas simulada. Por isso, foquei em construir a interface, a navegação entre telas e a lógica local das tarefas. O usuário consegue entrar pela tela de login ou cadastro, escolher um dia no calendário e controlar as tarefas daquele dia.

## 2. Organizacao do projeto

Procurei organizar o código em pastas separadas para não deixar toda a lógica dentro de um único arquivo. A estrutura ficou assim:

```text
lib/
  main.dart
  controllers/
    task_controller.dart
  helpers/
    date_formatters.dart
  models/
    task.dart
  screens/
    auth_screen.dart
    planner_screen.dart
  theme/
    app_theme.dart
  widgets/
    acqa_calendar.dart
    add_task_dialog.dart
    glass_surface.dart
    task_list.dart
    vibrant_backdrop.dart
```

Essa separação me ajudou a entender melhor a responsabilidade de cada parte do projeto. A pasta `models` ficou com a estrutura dos dados, `controllers` ficou com a regra de negócio das tarefas, `screens` ficou com as telas principais, `widgets` ficou com componentes reutilizáveis, `helpers` ficou com funções auxiliares de data e `theme` concentrou as cores e estilos do aplicativo.

O projeto possui 12 arquivos Dart e não utiliza pacotes externos além do próprio Flutter. Isso foi importante porque me obrigou a implementar manualmente o calendário, os diálogos, o tema e os componentes visuais, em vez de depender de bibliotecas prontas.

## 3. Entrada do aplicativo

O arquivo `main.dart` é o ponto inicial da aplicação Nele, a função `main()`chama `runApp`, que inicia o widget principal:

```dart
void main() {
  runApp(const AcqaTarefasApp());
}
```

A classe `AcqaTarefasApp`usa `MaterialApp`, define o título do app, remove a faixa de debug e configura os temas claro e escuro. Um ponto que achei interessante foi o uso de:

```dart
themeMode: ThemeMode.system
```

Com isso, o aplicativo acompanha automaticamente o tema do sistema operacional. Se o usuário estiver usando modo escuro, o app abre em dark mode; se estiver em modo claro, abre no tema claro.

Nesse arquivo também tive meu primeiro contato com `StatelessWidget`. Entendi que esse tipo de widget é usado quando a tela ou componente não precisa guardar um estado interno próprio.

## 4. Modelo de dados da tarefa.

O arquivo `task.dart` possui a classe `Task`, que representa uma tarefa da lista. Ela tem quatro informações principais:


- `id`: identificador único da tarefa;

- `title`: texto da tarefa;

- `date`: data em que a tarefa foi cadastrada;

- `completed`: indica se a tarefa foi concluída ou não.

O campo `completed` vem com valor padrão `false`, ou seja, toda tarefa nova já nasce como pendente. Isso atende diretamente ao requisito da atividade.

Também usei um método chamado `copyWith`:

```dart
Task copyWith({String? id, String? title, DateTime? date, bool? completed}) {
  return Task(
    id: id ?? this.id,
    title: title ?? this.title,
    date: date ?? this.date,
    completed: completed ?? this.completed,
  );
}
```

No começo, eu não entendia muito bem por que criar uma cópia em vez de simplesmente alterar o objeto. Depois percebi que essa abordagem deixa o código mais organizado, porque a tarefa original continua imutável e, quando preciso mudar algo, crio uma nova versão dela. Usei isso principalmente para marcar e desmarcar uma tarefa como concluída.

## 5. Controle das tarefas

A regra principal do aplicativo está no arquivo `task_controller.dart`. Nele criei a classe `TaskController`, que estende `ChangeNotifier`. Esse controller guarda a lista de tarefas e possui os métodos para adicionar, remover, contar e alterar o status das tarefas.

O uso do `ChangeNotifier` foi um dos aprendizados mais importantes. Quando uma tarefa é adicionada, removida ou alterada, o controller chama:

```dart
notifyListeners();
```

Isso avisa a interface que houve mudança nos dados. Na tela principal, essa atualização é percebida por meio de um `AnimatedBuilder`, que reconstrói a interface quando o controller muda.

O método mais importante é o `tasksFor`, que filtra as tarefas de uma data específica e também faz a ordenação exigida pela atividade:

```dart
filtered.sort((first, second) {
  if (first.completed != second.completed) {
    return first.completed ? 1 : -1;
  }

  return first.title.toLowerCase().compareTo(second.title.toLowerCase());
});
```

Essa parte garante duas regras:

- Tarefas pendentes aparecem primeiro;

— Dentro de pendentes e concluídas, os nomes ficam em ordem alfabética.

Foi aqui que pratiquei melhor o uso de listas em Dart, principalmente `where`, `toList`, `sort` e `compareTo`.

## 6. Tratamento de datas

No arquivo `date_formatters.dart`, criei listas com nomes de meses e dias da semana em português, além de funções auxiliares para trabalhar com datas.

A função `dateOnly` foi necessária porque o `DateTime` guarda data e horário Se duas tarefas forem do mesmo dia, mas com horários diferentes, uma comparação direta poderia dar errado. Para resolver isso, a função cria uma nova data usando apenas ano, mês e dia:

```dart
DateTime dateOnly(DateTime value) {
  return DateTime(value.year, value.month, value.day);
}
```

Também usei `isSameDay` para comparar datas e funções como `formatMonthYear` e `formatLongDate` para deixar as datas mais legíveis na interface.

## 7. Tela de login e cadastro

A tela `auth_screen.dart` possui login e cadastro no mesmo lugar. Para alternar entre os dois modos, usei um `enum`:

```dart
enum AuthMode { login, register }
```

Usei `StatefulWidget` porque essa tela precisa guardar informações que mudam, como o modo atual, o texto digitado e se a senha está oculta ou visível.

Os campos usam `TextEditingController`, e aprendi que é importante chamar `dispose()` nesses controllers para liberar memória quando a tela for fechada.

Também usei `Form`, `GlobalKey<FormState>`, e `TextFormField` para validar os dados. O e-mail precisa ter `@` e `.`, e a senha precisa ter pelo menos 6 caracteres. No cadastro, o nome precisa ter pelo menos 3 letras.

Um detalhe de interface foi o uso de `SegmentedButton`, que deixa claro se o usuário está no modo Login ou Cadastro. O campo de nome aparece somente no cadastro usando `AnimatedSwitcher`, criando uma transição mais suave.

Quando o formulário está válido, uso `Navigator.pushReplacement` para ir para a tela principal. Escolhi `pushReplacement` porque não queria que o usuário voltasse para a tela de login usando o botão de voltar.

## 8. Tela principal

A tela principal está em `planner_screen.dart`. Ela concentra a navegação entre o calendário e a lista de tarefas.

Usei três estados principais:

- `_taskController`: controla as tarefas;

- `_selectedDate`: guarda o dia selecionado;

- `_tabIndex`: indica se o usuário está na aba Calendário ou Tarefas.

Para alternar entre as duas partes da tela, usei `IndexedStack`:

```dart
IndexedStack(
  index: _tabIndex,
  children: [
    CalendarPage(...),
    TasksPage(...),
  ],
)
```

Eu escolhi essa estrutura porque ela mantém as duas telas carregadas e apenas troca qual está visível. Assim, o calendário não perde o estado quando o usuário vai para a lista de tarefas e volta.

Também criei uma barra inferior própria, chamada `_PlannerTabBar`, em vez de usar apenas uma navegação padrão. Nela, os botões de Calendário e Tarefas possuem gradiente, bordas arredondadas e uma animação simples com `AnimatedContainer`. Isso deixou a interface mais personalizada.

O botão flutuante muda conforme a aba:

- No calendário, ele leva para a lista de tarefas;

— Na aba Tarefas, ele abre o cadastro de nova tarefa.

Essa solução deixou a interface mais limpa, porque aproveita o mesmo espaço para a ação principal de cada tela.

## 9. Calendario

O calendário foi desenvolvido no arquivo `acqa_calendar.dart`, sem uso de biblioteca pronta. Para montar os dias, usei `GridView.builder`. O cálculo principal considera:

- o primeiro dia do mês;

- a quantidade de dias do mês;

- quantos espaços vazios precisam aparecer antes do dia 1;

- a quantidade total de células para manter a grade alinhada.

Um trecho que achei interessante foi este:

```dart
final daysInMonth = DateTime(
  visibleMonth.year,
  visibleMonth.month + 1,
  0,
).day;
```

Ele pega o dia 0 do mês seguinte, que na prática retorna o último dia do mês atual. Foi uma solução simples para descobrir se o mês tem 28, 29, 30 ou 31 dias.

Cada dia do calendário é uma célula clicável. O dia selecionado muda de cor, o dia atual recebe uma borda diferente e os dias com tarefas mostram um pequeno marcador com a quantidade de tarefas.

Durante os testes, apareceu um erro de `bottom overflow`, principalmente quando a janela estava pequena. Resolvi esse problema usando `Stack` dentro da célula do calendário Assim, o número do dia fica fixo no topo e o contador de tarefas fica no canto inferior, sem empurrar o layout para fora.

## 10. Lista de tarefas

A lista foi criada em "usando". Cada tarefa aparece como um item com:

- Checkbox para marcar como concluída;

- texto da tarefa;

- etiqueta de status, como "Pendente" ou "Concluída";

- botão de remover;

- suporte a arrastar para apagar com `Dismissible`.

Quando uma tarefa é concluída, o texto fica riscado usando `TextDecoration.lineThrough`. Isso ajuda visualmente o usuário a perceber que a tarefa já foi feita.

Também criei uma tela vazia para quando não existem tarefas naquele dia. Em vez de deixar a lista em branco, mostro uma mensagem com ícone e instrução para adicionar uma nova tarefa.

## 11. Dialogo para adicionar tarefa

O cadastro de tarefas foi feito em `add_task_dialog.dart`. Usei `showDialog` para abrir uma janela pequena em cima da tela atual. A função retorna um `Future<String?>`, pois o usuário pode confirmar uma tarefa ou cancelar.

Dentro do diálogo, existe um formulário com validação A tarefa precisa ter pelo menos 3 letras. Quando o usuário confirma, o texto volta para a tela principal e o controller adiciona a nova tarefa na data selecionada.

Essa parte me ajudou a entender melhor o uso de `Future`, pois a tela precisa esperar o resultado do diálogo antes de adicionar a tarefa.

## 12. Tema e design

Uma parte que tentei trabalhar com mais cuidado foi o design. A atividade pedia criatividade e cores vibrantes, então tentei fugir de uma tela muito comum.

Criei o arquivo `app_theme.dart` para centralizar a aparência do aplicativo. Nele defini:

- cores principais, como azul, coral, verde, violeta e amarelo;

- tema claro e tema escuro;

- estilos de campos de texto, botões, checkbox, snackbar e app bar;

- uma extensão de tema chamada `AppPalette`.

A `AppPalette` foi uma estrutura que achei mais avançada, mas muito útil Com ela, consegui guardar cores personalizadas para fundo, texto, vidro, bordas e estados. Depois, em qualquer widget, acesso essas cores com:

```dart
final palette = context.palette;
```

Para criar o efeito visual de vidro, desenvolvi o widget `GlassSurface`. Ele usa `BackdropFilter` com `ImageFilter.blur`, além de uma cor semitransparente e sombra suave. Usei esse componente em vários lugares: tela de login, calendário, cabeçalhos, barra inferior e diálogo.

Também criei o `VibrantBackdrop`, que usa `CustomPainter` para desenhar o fundo. Ele cria formas coloridas e faixas curvas usando `Canvas`, `Paint`, e `Path`. Essa foi uma parte mais difícil, porque é uma forma de desenhar mais manual, mas gostei do resultado porque deixou o aplicativo com identidade própria.

No meio do desenvolvimento, tive um problema com ícones aparecendo como quadrados. Descobri que era por causa de ícones Cupertino que dependiam de uma fonte específica Para resolver, troquei para ícones Material, que funcionam corretamente com `uses-material-design: true`.

## 13. Dificuldades encontradas:

Como foi meu primeiro contato com Flutter, algumas partes exigiram mais testes:

- entender a diferença entre `StatelessWidget` e `StatefulWidget`;

- entender quando usar `setState` e quando usar `ChangeNotifier`;

- montar o calendário manualmente;

- resolver problemas de overflow em telas menores;

- organizar o projeto em vários arquivos;

- Lidar com tema claro e escuro;

- entender por que alguns ícones apareciam como quadrados.

Esses problemas ajudaram no aprendizado, porque me obrigaram a testar, ler mensagens de erro e ajustar a estrutura do código.

## 14. Conclusão

O desenvolvimento desta ACQA foi uma experiencia importante para aplicar conceitos de programacao em um projeto visual e funcional. Mesmo sendo meu primeiro contato com Dart e Flutter, consegui criar um aplicativo com login/cadastro, calendário mensal, lista de tarefas por dia, cadastro de tarefas, remoção e marcação como concluída.

Aprendi que Flutter trabalha muito com composição de widgets e que uma boa organização facilita bastante a manutenção do código Também entendi melhor a importância de separar modelo, controller, telas e widgets, para que cada parte tenha uma responsabilidade mais clara.

Do ponto de vista técnico, pratiquei listas, filtros, ordenação, datas, formulários, validações, callbacks, controle de estado e construção de layouts responsivos. Do ponto de vista visual, aprendi a trabalhar com temas, dark mode, cores, bordas, sombras, efeitos de vidro e pintura customizada.
Concluo que o projeto cumpriu os requisitos propostos e tambem serviu como uma boa introducao ao desenvolvimento mobile com Flutter. A maior licao foi perceber que criar um aplicativo envolve tanto a logica quanto a experiencia do usuario, e que pequenos detalhes de interface fazem muita diferenca no resultado final.
