package interlude;

typedef Task<X>                     = interlude.reactive.Task<X>;
typedef Surprise<X>                 = interlude.reactive.Surprise<X>;
typedef Observable<X>               = interlude.reactive.Observable<X>;

@:dox(hide) typedef TaskTools       = interlude.reactive.Task.TaskTools;
@:dox(hide) typedef SurpriseTools   = interlude.reactive.Surprise.SurpriseTools;
@:dox(hide) typedef ObservableTools = interlude.reactive.Observable.ObservableTools;