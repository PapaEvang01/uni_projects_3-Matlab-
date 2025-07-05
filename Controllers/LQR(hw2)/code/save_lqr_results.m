function save_lqr_results(filename, K, final_state)
    fid = fopen(filename, 'w');
    if fid == -1
        warning('Failed to write results.');
        return;
    end

    fprintf(fid, 'LQR Controller Results\n');
    fprintf(fid, '-----------------------\n');
    fprintf(fid, 'Gain matrix K:\n');
    fprintf(fid, 'K = [%.6f  %.6f]\n', K(1), K(2));
    fprintf(fid, '\nFinal state:\n');
    fprintf(fid, 'x1 (position) = %.6f\n', final_state(1));
    fprintf(fid, 'x2 (velocity) = %.6f\n', final_state(2));
    fprintf(fid, '\nLogged on: %s\n', datestr(now));
    fclose(fid);
    fprintf('[?] Results saved to "%s"\n', filename);
end
