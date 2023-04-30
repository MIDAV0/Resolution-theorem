## Resolution theorem prover in ProLog

## Instructions

In prolog console run `test(X).` where X is a theorem in form like:

1. ((x imp y) and x) imp y
2. (neg x imp y) imp (neg (x notimp y) imp y)
3. ((x imp y) and (y imp z)) imp (neg neg z or neg x)
4. (x imp (y imp z)) equiv ((x imp y) imp z)
5. (x notequiv y) equiv (y notequiv x)
6. (x notequiv (y notequiv z)) equiv ((x notequiv y) notequiv z)
7. (neg x downarrow neg y) revimp neg (x uparrow y)
8. (neg x revimp neg y) and ((z notrevimp u) or (u uparrow neg v))
9. ((x or y) imp (neg y notrevimp z)) or (neg neg (z equiv x) notrevimp y)
10. (neg (z notrevimp y) revimp x) imp ((x or w) imp ((y imp z) or w))

Output is `YES` or `NO`.
