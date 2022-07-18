=========
Real mode
=========

-------------------
Screen manipulation
-------------------

Scrolling window
~~~~~~~~~~~~~~~~

We use scrolling to clean screen

::

    AH = 06h
    AL = number of lines by which to scroll up (00h = clear entire window)
    BH = attribute used to write blank lines at bottom of window
    CH,CL = row,column of window's upper left corner
    DH,DL = row,column of window's lower right corner

    Return:
    Nothing

