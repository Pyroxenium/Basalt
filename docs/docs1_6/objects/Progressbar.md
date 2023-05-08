Progressbars are objects to visually display the current state of your progression. They always go from 0 to 100 (%) - no matter how big they are. which means if you
want to add some energy progress you have to do simple maths: currentValue / maxValue * 100

[Object](objects/Object.md) methods also apply for progressbars.

|   |   |
|---|---|
|[setDirection](objects/Progressbar/setDirection.md)|Sets the progress direction
|[setProgress](objects/Progressbar/setProgress.md)|Sets the current progress
|[getProgress](objects/Progressbar/getProgress.md)|Returns the current progress
|[setProgressBar](objects/Progressbar/setProgressBar.md)|Changes the progress design
|[setBackgroundSymbol](objects/Progressbar/setBackgroundSymbol.md)|Sets the background symbol

# Events

This is a list of all available events for progressbars:

|   |   |
|---|---|
|[onDone](objects/Progressbar/onDone.md)|Fires when a progress has finished
