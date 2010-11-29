aiObjectiveC
============

aiObjectiveC is an Asset Importer renderer written in OpenGL, using Objective-C.
It initializes OpenGL-friendly data structures based on data imported using
Assimp and lets you render it in a simple fashion.

It also adds categories to Cocoa classes to interface with Assimp's utility
classes. (Currently only +[NSString stringWithAIString:])

Ideally, aiObjectiveC should support every feature that is exposed from Assimp,
but in practice this isn't the case. This is due to two reasons:

 1. Time constraints: I will be incrementally adding features that I need, and I
    will skip features I don't use.
 2. Context-sensitive features: Not all features of assimp are cleary defined -
    some of them depend on the artist / developer and where they are being used.
    Different people assign different values to some of these fields.

In the second case, I will either not implement a feature, or I will implement
it in the way I will be using it - which might not match your use-case.

If you find a feature missing in aiObjectiveC, and implement it yourself, I'll
gladly take a look at your patch - and probably add it to the repository. Let me
know!

Finally, aiObjectiveC is meant as a starting ground for people wanting to write
OpenGL apps for Mac / iOS that leverage assimp. You might not want to use my
library verbatim, but hopefully it'll help you get started!

This is currently considered a prototype, and a C++ API based on this will
probably be developed after it stabilizes a bit. This is in order to have a
platform-independent way of working with assimp and OpenGL.


License
=======

aiObjectiveC is licensed under the BSD license, see the file "LICENSE" that
should be shipped alongside this readme.

You are free to do as you please with aiObjectiveC, but if you make any changes
to it that others could benefit from, I would greatly appreciate it if you
contribute them back.

In addition, if you use aiObjectiveC in your app, I'd love it if you could link
to this project from somewhere (like your readme, about box, etc).
