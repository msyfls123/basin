export class Defer {
    constructor(name: string)
    run: (time: number) => Promise<string>
}
