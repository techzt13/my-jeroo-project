export const pythonMode: any = {
    start: [
        {
            regex: /def|while|if|else|elif/,
            token: 'keyword'
        },
        {
            regex: /True|False|new|NORTH|SOUTH|EAST|WEST|AHEAD|LEFT|RIGHT|HERE|not|and|or/,
            token: 'atom'
        },
        {
            regex: /[+-]/,
            token: 'operator'
        },
        {
            regex: /[a-zA-Z][a-zA-Z0-9]*/,
            token: 'variable'
        },
        {
            regex: /[+-]?[0-9]+/,
            token: 'number'
        },
        {
            regex: /:/,
            indent: true
        },
        {
            regex: /#.*/,
            token: 'comment'
        },
        {
            regex: /"""/,
            token: 'comment',
            next: 'comment'
        }
    ],
    comment: [
        {
            regex: /.*?"""/,
            token: 'comment',
            next: 'start'
        },
        {
            regex: /.*/,
            token: 'comment'
        }
    ],
    meta: {
        dontIndentStates: ['comment'],
        lineComment: '#'
    }
};
