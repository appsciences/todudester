# todudester

Todo for dudesters only

## Code comments

In this example, we create a Flutter app with a TodoListScreen as the main screen. It contains four different lists (todoList1, todoList2, todoList3, and todoList4). The activeListIndex variable keeps track of the currently selected list.

The app uses an AppBar for the title and a Column for the layout. The top row contains buttons to switch between the four lists. The active list is highlighted with a blue background color.

The main content area uses a ListView.builder to display the tasks of the currently active list. Each task has a delete button to remove it from the list.

At the bottom of the screen, there is a TextField where the user can enter new tasks. Pressing Enter or tapping the add button will add the task to the active list.

To handle keyboard shortcuts, we use a RawKeyboardListener widget. It listens to raw keyboard events and calls the _handleKeyEvent method. Pressing the arrow up key will navigate to the previous list (if available), while pressing the arrow down key will navigate to the next list (if available).

Please note that this code is just a basic example to get you started. You can customize and enhance it further according to your specific requirements.