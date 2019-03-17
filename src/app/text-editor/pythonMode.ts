export const pythonMode: any = {
    start: [
        {
            regex: /def|while|if|else|elif/,
            token: 'keyword'
        },
        {
            regex: /True|False|new|NORTH|SOUTH|EAST|WEST|AHEAD|LEFT|RIGHT|HERE/,
            token: 'atom'
        },
        {
            regex: /[+-]?[0-9]+/,
            token: 'number'
        },
        {
            regex: /and|or|not|[+-]/,
            token: 'operator'
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
