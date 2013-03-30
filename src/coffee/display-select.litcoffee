Display Selection
=================

The display selector -- as its name probably suggests -- selects what to display
on screen, other than overrides taking priority.

Core Logic
----------

We structure the core logic as a simple series of conditionals.

    selectedDisplay = (state) ->

If the kill mode is active, we display a no entry sign on all displays.

As an exception, judges' displays are not public-facing: on those
we display the origin of the kill.

        return 'no-entry' if state.kill? unless state.mode is 'judge'
        return 'kill-origin' if state.kill? and state.mode is 'judge'

In all other cases, fall back to the default view.

        return 'default'

Public Property
---------------

First, we define the *data source*, which combines all the streams which the
display selector uses as input.

    dataSource = Bacon.combineTemplate
                     mode: Data.mode,
                     kill: Data.killState

We then use *selectedDisplay* to map the data source, followed by
a final pass to skip duplicates, so that we do not flap display
modes.

    window.SelectedDisplay = dataSource.map(selectedDisplay)
                                       .skipDuplicates()

